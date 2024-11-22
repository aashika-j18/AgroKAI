<!-- Improved compatibility of back to top link: See: https://github.com/othneildrew/Best-README-Template/pull/73 -->
<a id="readme-top"></a>
<!--
*** Thanks for checking out the Best-README-Template. If you have a suggestion
*** that would make this better, please fork the repo and create a pull request
*** or simply open an issue with the tag "enhancement".
*** Don't forget to give the project a star!
*** Thanks again! Now go create something AMAZING! :D
-->



<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->



<!-- PROJECT LOGO -->
<br />
<div>

  <h1>AgroKAI</h1>

  <p>
    An awesome README template to jumpstart your projects!
    <br />
  </p>
</div>



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
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>

## About The Project

[![Product Name Screen Shot][product-screenshot]](https://example.com)

AgroKAI is a smart farming app designed to simplify agricultural management for farmers, with functionalities that provide insights on soil fertility, predict plant diseases, and help optimize irrigation. Built on Flutter and Firebase, AgroKAI utilizes machine learning and sensor data integration to enhance decision-making in farming. 

The app is divided into three main parts:
1. **Plant Disease Detection** - Uses a TensorFlow Lite (TFLite) image classification model to detect potential plant diseases from images, offering organic solution suggestions.
2. **Soil Fertility Monitoring** - Tracks changes in soil fertility, nitrogen (N), phosphorus (P), and potassium (K) levels, predicting future fertility trends through a random forest regression model.
3. **Irrigation Management** - Calculates crop water requirements using real-time environmental data (rainfall, humidity, temperature, wind speed) and sets up the motor timer, integrating motor control and usage logs.

Data is stored and accessed in Firebase Firestore through three primary collections: soil data, irrigation data, and motor logs.

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


<!-- GETTING STARTED -->
## Getting Started

To set up a local copy of AgroKAI and start developing or testing the app, follow these steps.

### Prerequisites

Ensure that you have Flutter installed and configured in your development environment. You can follow the [official Flutter installation guide](https://flutter.dev/docs/get-started/install) for setup instructions.

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

6. **Run the App**
   Connect a device or start an emulator, then use the following command to launch the app:
   ```sh
   flutter run
   ```

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- USAGE EXAMPLES -->
## Usage

Use this space to show useful examples of how a project can be used. Additional screenshots, code examples and demos work well in this space. You may also link to more resources.

_For more examples, please refer to the [Documentation](https://example.com)_

<p align="right">(<a href="#readme-top">back to top</a>)</p>






### Contributors:
 
<a href="https://github.com/aashika-j18">
  <img src="https://avatars.githubusercontent.com/aashika-j18?v=4" width="100px" height="100px" style="border-radius: 50%;" alt="aashika-j18" />
</a>  
<a href="https://github.com/kv-06">
  <img src="https://avatars.githubusercontent.com/kv-06?v=4" width="100px" height="100px" style="border-radius: 50%;" alt="kv-06" />
</a>  
<a href="https://github.com/ckritk">
  <img src="https://avatars.githubusercontent.com/ckritk?v=4" width="100px" height="100px" style="border-radius: 50%;" alt="ckritk" />
</a> 

<p align="right">(<a href="#readme-top">back to top</a>)</p>




### Acknowledgments  
We’d like to thank the following resources, tools, and frameworks that made the development of AgroKAI possible:

- [Flutter Documentation](https://flutter.dev/docs) 
- [Firebase Console](https://firebase.google.com/) 
- [TensorFlow Lite](https://www.tensorflow.org/lite) 
- [Scikit-Learn Documentation](https://scikit-learn.org/stable/documentation.html) 
- [Img Shields](https://shields.io/)  
- [Font Awesome](https://fontawesome.com/)  
- [REST API Best Practices](https://restfulapi.net/) 
- [GitHub Pages](https://pages.github.com/) 

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/othneildrew/Best-README-Template.svg?style=for-the-badge
[contributors-url]: https://github.com/othneildrew/Best-README-Template/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/othneildrew/Best-README-Template.svg?style=for-the-badge
[forks-url]: https://github.com/othneildrew/Best-README-Template/network/members
[stars-shield]: https://img.shields.io/github/stars/othneildrew/Best-README-Template.svg?style=for-the-badge
[stars-url]: https://github.com/othneildrew/Best-README-Template/stargazers
[issues-shield]: https://img.shields.io/github/issues/othneildrew/Best-README-Template.svg?style=for-the-badge
[issues-url]: https://github.com/othneildrew/Best-README-Template/issues
[license-shield]: https://img.shields.io/github/license/othneildrew/Best-README-Template.svg?style=for-the-badge
[license-url]: https://github.com/othneildrew/Best-README-Template/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/othneildrew
[product-screenshot]: images/screenshot.png
[Next.js]: https://img.shields.io/badge/next.js-000000?style=for-the-badge&logo=nextdotjs&logoColor=white
[Next-url]: https://nextjs.org/
[React.js]: https://img.shields.io/badge/React-20232A?style=for-the-badge&logo=react&logoColor=61DAFB
[React-url]: https://reactjs.org/
[Vue.js]: https://img.shields.io/badge/Vue.js-35495E?style=for-the-badge&logo=vuedotjs&logoColor=4FC08D
[Vue-url]: https://vuejs.org/
[Angular.io]: https://img.shields.io/badge/Angular-DD0031?style=for-the-badge&logo=angular&logoColor=white
[Angular-url]: https://angular.io/
[Svelte.dev]: https://img.shields.io/badge/Svelte-4A4A55?style=for-the-badge&logo=svelte&logoColor=FF3E00
[Svelte-url]: https://svelte.dev/
[Laravel.com]: https://img.shields.io/badge/Laravel-FF2D20?style=for-the-badge&logo=laravel&logoColor=white
[Laravel-url]: https://laravel.com
[Bootstrap.com]: https://img.shields.io/badge/Bootstrap-563D7C?style=for-the-badge&logo=bootstrap&logoColor=white
[Bootstrap-url]: https://getbootstrap.com
[JQuery.com]: https://img.shields.io/badge/jQuery-0769AD?style=for-the-badge&logo=jquery&logoColor=white
[JQuery-url]: https://jquery.com 
