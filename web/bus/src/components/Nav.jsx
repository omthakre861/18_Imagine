import React from 'react'
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


const Nav = () => {
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

  
  return (
      null
  )
}

export default Nav