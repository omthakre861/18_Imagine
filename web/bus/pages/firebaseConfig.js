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

const getCurrentUser = () => {
  return auth.currentUser;
}

async function getTrips() {
  const tripSchedule = collection(db, 'Trip_Schedule');
  const tripSnapshot = await getDocs(tripSchedule);
  const tripList = tripSnapshot.docs.map(doc => doc.data());
  return tripList;
}

const googleProvider = new GoogleAuthProvider();

const signInWithGoogle = async () => {
  try {
    const res = await signInWithPopup(auth, googleProvider);
    const user = res.user;
    const q = query(collection(db, "users"), where("uid", "==", user.uid));
    const docs = await getDocs(q);
    if (docs.docs.length === 0) {
      await addDoc(collection(db, "users"), {
        uid: user.uid,
        name: user.displayName,
        authProvider: "google",
        email: user.email,
      });
    }
  } catch (err) {
    console.error(err);
    alert(err.message);
  }
};

const logInWithEmailAndPassword = async (email, password) => {
    try {
      await signInWithEmailAndPassword(auth, email, password);
    } catch (err) {
      console.error(err);
      alert(err.message);
    }
};
  
const registerWithEmailAndPassword = async (name, email, password) => {
    try {
      const res = await createUserWithEmailAndPassword(auth, email, password).then(userCredential => {
        if (userCredential.user) {
          updateProfile( userCredential.user, {displayName: name})
        }
      });
      
    } catch (err) {
      console.error(err);
      alert(err.message);
    }
};
  
const sendPasswordReset = async (email) => {
    try {
      await sendPasswordResetEmail(auth, email);
      alert("Password reset link sent!");
    } catch (err) {
      console.error(err);
      alert(err.message);
    }
};
  
const logout = () => {
    signOut(auth);
};
  
export {
    app,
    auth,
    db,
    signInWithGoogle,
    logInWithEmailAndPassword,
    registerWithEmailAndPassword,
    sendPasswordReset,
  logout,
  getTrips,
  getCurrentUser
  };