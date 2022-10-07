import React, { useEffect } from 'react'
import { signInWithGoogle,logInWithEmailAndPassword,sendPasswordReset,logout } from '../../pages/firebase'
import { initializeApp } from "firebase/app";


import {
    updateProfile,
    GoogleAuthProvider,
    getAuth,
    signInWithPopup,
    signInWithEmailAndPassword,
    createUserWithEmailAndPassword,
    sendPasswordResetEmail,
    signOut,
} from "firebase/auth";

import {
    getFirestore,
    query,
    getDocs,
    collection,
    where,
    addDoc,
} from "firebase/firestore";


const Login = ({ SetAuth }) => {
    let [username, setUsername] = React.useState("");
    let [password, setPassword] = React.useState("");

    const firebaseConfig = {
        apiKey: "AIzaSyBOizeqiuWCAOyxtT_8FC0ZqUnf8b2mm-k",
        authDomain: "bus-booking-something.firebaseapp.com",
        databaseURL: "https://bus-booking-something-default-rtdb.asia-southeast1.firebasedatabase.app",
        projectId: "bus-booking-something",
        storageBucket: "bus-booking-something.appspot.com",
        messagingSenderId: "958529699742",
        appId: "1:958529699742:web:7b6bfac387fe6f1a5ee08f"
      };

    const app = initializeApp(firebaseConfig);
    const auth = getAuth(app);
    const db = getFirestore(app);


    function setUname(e) {
        setUsername(e.target.value) 
    }
    
    function setPass(e) {
        setPassword(e.target.value) 
    }
    
    function loginButton() {
        logInWithEmailAndPassword(username, password);
    }
    
    function signinWithGoogle() {
        signInWithGoogle();
        SetAuth(auth);
    }



  return (
      <div className='position-absolute'>
          <div className='black-background'></div>
          <div className="main-cont-login">
              <h1>Login.</h1>
              <h2>Username: </h2>
              <input type="text" className='username' onChange={setUname}  />

              <h2>Password: </h2>
              <input type="password" className="password" onChange={setPass}/>
              <h4 onClick={sendPasswordReset}>Forgot password ?</h4>
              <div className="flex-row">
                  
                <button onClick = {loginButton} >Login</button>
                <button onClick = {signinWithGoogle} ><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-google" viewBox="0 0 16 16">
  <path d="M15.545 6.558a9.42 9.42 0 0 1 .139 1.626c0 2.434-.87 4.492-2.384 5.885h.002C11.978 15.292 10.158 16 8 16A8 8 0 1 1 8 0a7.689 7.689 0 0 1 5.352 2.082l-2.284 2.284A4.347 4.347 0 0 0 8 3.166c-2.087 0-3.86 1.408-4.492 3.304a4.792 4.792 0 0 0 0 3.063h.003c.635 1.893 2.405 3.301 4.492 3.301 1.078 0 2.004-.276 2.722-.764h-.003a3.702 3.702 0 0 0 1.599-2.431H8v-3.08h7.545z"/>
</svg></button>
              </div>
          </div>
    </div>
  )
}

export default Login