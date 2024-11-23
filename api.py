import torch
from flask import Flask, request, jsonify
from PIL import Image
import numpy as np
import tensorflow_hub as hub
import pickle
import pandas as pd

import json
import tensorflow as tf


# Load the model
#img_model = hub.load("https://www.kaggle.com/models/rishitdagli/plant-disease/TensorFlow2/plant-disease/1")

app = Flask(__name__)



def load_model(model_path):
    interpreter = tf.lite.Interpreter(model_path=model_path)
    interpreter.allocate_tensors()
    return interpreter

def preprocess_image(image, target_size=(224, 224)):
    img = image.convert('RGB')  # Open the image and convert to RGB
    img = img.resize(target_size)  # Resize to 224x224 (as expected by the model)
    img_array = np.array(img) / 255.0  # Normalize pixel values to [0, 1] range
    img_array = np.expand_dims(img_array, axis=0)  # Add batch dimension (1, 224, 224, 3)
    img_array = img_array.astype(np.float32)  # Explicitly convert to float32
    return img_array

def predict_with_tflite(interpreter, input_data):
    input_details = interpreter.get_input_details()
    output_details = interpreter.get_output_details()
    
    # Set the input tensor
    interpreter.set_tensor(input_details[0]['index'], input_data)
    
    # Run inference
    interpreter.invoke()
    
    # Get the output tensor (predictions)
    output_data = interpreter.get_tensor(output_details[0]['index'])
    
    return output_data

with open(r'C:\Users\Aashi\Documents\Co-curricular\agro_kai_stuff\solution_data.json','r') as file:
    solution_data=json.load(file)

interpreter = load_model(r"C:\Users\Aashi\Documents\Co-curricular\agro_kai_stuff\plant_disease_detection.tflite")

@app.route('/predict_disease', methods=['POST'])
def predict_disease():
    if 'file' not in request.files:
        return jsonify({'error': 'No file uploaded'}), 400
    
    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No selected file'}), 400

    try:
        # Save the image temporarily
        image = Image.open(file.stream)
        processed_image = preprocess_image(image)

        # Run the model and get predictions
        #predictions = img_model(processed_image).numpy()
        predictions = predict_with_tflite(interpreter, processed_image)
        predicted_class = np.argmax(predictions)

        # Map to disease name
        predicted_disease = solution_data.get(str(predicted_class))[0].get("name")
        solutions=solution_data.get(str(predicted_class))[0].get("solutions")
       
            
        #print(predicted_class)
        #print(predicted_disease)
        #print(solutions)
        return jsonify({'prediction': predicted_disease, 'solutions':solutions})
        
    except Exception as e:
        print(f"Error processing image: {e}")
        return jsonify({'error': 'Image processing failed'}), 500



@app.route('/search_cures', methods=['GET'])
def search_cures():
    query = request.args.get('query', '').lower()
    matching_solutions=[]

    for index in solution_data:
        if (query in solution_data[index][0].get('name').lower()) and ("healthy" not in solution_data[index][0].get('name').lower()):

            solutions=solution_data[index][0].get("solutions")
            matching_solutions.append({ "name": solution_data[index][0].get('name'),"solutions":solutions})


     
    #print(jsonify(matching_solutions))
    return jsonify(matching_solutions)


# Load the model from the pickle file
with open(r"C:\Users\Aashi\Documents\Co-curricular\agro_kai_stuff\crop_yield_prediction_model.pkl", 'rb') as f:
    soil_model = pickle.load(f)

with open(r"C:\Users\Aashi\Documents\Co-curricular\agro_kai_stuff\min_max_values.pkl", 'rb') as f:
  min_max_values = pickle.load(f)

def normalize_input(input_data, numerical_cols, min_max_values):
  """Normalizes the input data using the previously calculated min-max values."""
  normalized_data = {}
  for i, col in enumerate(numerical_cols):
      print(i,col)
      normalized_data[col] = (input_data[i] - min_max_values[col]['min']) / (min_max_values[col]['max'] - min_max_values[col]['min'])
  return normalized_data


@app.route('/predict_soil', methods=['POST'])
def predict_soil():
    try:
        # Get the data from the request
        data = request.get_json()
        #print("Received data:", data)

        # Extract the values in the order expected by the model
        features = [
            data['N'], data['P'], data['K'], data['ph'], data['ec'],
            data['oc'], data['S'], data['zn'], data['fe'], data['cu'],
            data['mn'], data['b']
        ]



        

        numerical_cols = ['N', 'P', 'K', 'pH', 'EC', 'OC', 'S', 'Zn', 'Fe', 'Cu', 'Mn', 'B']
        normalized_input = normalize_input(features, numerical_cols, min_max_values)
        #print("normalised",normalized_input)

        # Create a DataFrame with the normalized input data
        input_df = pd.DataFrame([normalized_input])

        

        # Make prediction
        prediction = soil_model.predict(input_df)
        #print(prediction)
        #print(str(prediction[0]))

        # Return the prediction as a JSON response
        return jsonify({'prediction': str(prediction[0])})
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500


if __name__=='__main__':
    app.run(host='0.0.0.0', port=5000)
