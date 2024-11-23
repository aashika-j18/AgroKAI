
<a id="readme-top"></a>


 <h1>AgroKAI 🌿</h1>




<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#contributors">Contributors</a></li>
  </ol>
</details>

<a id="about-the-project"></a>
## About The Project



AgroKAI is a smart farming app designed to simplify agricultural management for farmers, with functionalities that provide insights on soil fertility, predict plant diseases, and help optimize irrigation. Built on Flutter and Firebase, AgroKAI utilizes machine learning and sensor data integration to enhance decision-making in farming. 

The app is divided into three main parts:
1. 🌾**Plant Disease Detection** - Uses a TensorFlow Lite (TFLite) image classification model to detect potential plant diseases from images, offering organic solution suggestions.
2. 🌏 **Soil Fertility Monitoring** - Tracks changes in soil fertility, nitrogen (N), phosphorus (P), and potassium (K) levels, predicting future fertility trends through a random forest regression model.
3. 💧 **Irrigation Management** - Calculates crop water requirements using real-time environmental data (rainfall, humidity, temperature, wind speed) and sets up the motor timer, integrating motor control and usage logs.

Data is stored and accessed in Firebase Firestore through three primary collections: soil data, irrigation data, and motor logs.

=======


AgroKAI aims to streamline farming practices by delivering actionable insights, all in a user-friendly mobile interface.
  
<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Built With


This project leverages the following frameworks and libraries:

* [![Flutter][Flutter.dev]][Flutter-url] - The primary framework for building the cross-platform app.
* [![Firebase][Firebase.com]][Firebase-url] - Used for real-time database, Firestore storage, and authentication.
* [![TensorFlow Lite][TFLite]][TFLite-url] - For the on-device plant disease detection model.
* [![Flask][Flask]][Flask-url] - To host the soil fertility and irrigation prediction models.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- MARKDOWN LINKS & IMAGES -->
[Flutter.dev]: https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white
[Flutter-url]: https://flutter.dev/
[Firebase.com]: https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=white
[Firebase-url]: https://firebase.google.com/
[TFLite]: https://img.shields.io/badge/TensorFlow_Lite-FF6F00?style=for-the-badge&logo=tensorflow&logoColor=white
[TFLite-url]: https://www.tensorflow.org/lite
[Flask]: https://img.shields.io/badge/Flask-000000?style=for-the-badge&logo=flask&logoColor=white
[Flask-url]: https://flask.palletsprojects.com/


<a id="getting-started"></a>
<!-- GETTING STARTED -->
## Getting Started

To set up a local copy of AgroKAI and start developing or testing the app, follow these steps.

<a id="prerequisites"></a>
### Prerequisites

Ensure that you have Flutter installed and configured in your development environment. You can follow the [official Flutter installation guide](https://flutter.dev/docs/get-started/install) for setup instructions.

<a id="installation"></a>
### Installation

Follow these instructions to install and configure AgroKAI:

1. **Clone the Repository**
   ```sh
   git clone https://github.com/your_username/AgroKAI.git
   ```

2. **Install Flutter Packages**  
   Navigate to the project directory and install all necessary packages:
   ```sh
   flutter pub get
   ```

3. **Set Up Firebase**
   - Go to [Firebase Console](https://firebase.google.com/) and create a new project.
   - Enable Firestore, Authentication, and any other services you plan to use.
   -Download the `google-services.json` file and add it to the `android/app` directory of your project. 

4. **Configure the Image Classification Model and REST API**
   - AgroKAI uses a TensorFlow Lite model for plant disease detection. Ensure that `disease_model.tflite` is placed in the correct assets directory.
   - REST APIs are required for soil fertility and plant disease predictions. Set up the APIs as per your requirements and update the API endpoints in the app configuration files.

5. **Change Git Remote URL (Optional)**
   To avoid accidental pushes to the main project repository, change the git remote URL:
   ```sh
   git remote set-url origin https://github.com/aashika-j18/AgroKAI.git
   git remote -v # confirm the changes
   ```
=======






<p align="right">(<a href="#readme-top">back to top</a>)</p>







<a id="contributors"></a>
### Contributors:
 
<a href="https://github.com/aashika-j18">
  <img src="https://avatars.githubusercontent.com/aashika-j18?v=4" width="100px" height="100px" style="clip-path: circle(50%); -webkit-clip-path: circle(50%);" alt="aashika-j18" />
</a>
<a href="https://github.com/kv-06">
  <img src="https://avatars.githubusercontent.com/kv-06?v=4" width="100px" height="100px" style="clip-path: circle(50%); -webkit-clip-path: circle(50%);" alt="kv-06" />
</a>
<a href="https://github.com/ckritk">
  <img src="https://avatars.githubusercontent.com/ckritk?v=4" width="100px" height="100px" style="clip-path: circle(50%); -webkit-clip-path: circle(50%);" alt="ckritk" />
</a>


<p align="right">(<a href="#readme-top">back to top</a>)</p>















