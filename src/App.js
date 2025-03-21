import logo from './logo.svg';
import './App.css';
import "bootstrap/dist/css/bootstrap.min.css";

import React, { useRef, useEffect, useState } from "react";

import { Canvas, useFrame   } from '@react-three/fiber';
import { OrbitControls } from '@react-three/drei';
import { GUI } from 'dat.gui';
import { Col, Row } from "react-bootstrap";

function App() {
	const height: number = 512;

	return (<>
		<Row className="mx-0 py-0 bg-dark" style={{height: height}}>
			<Col>
				<Canvas>
					<Torus />
				</Canvas>
			</Col>
		</Row>
		<Row className="mx-0 py-0 bg-dark" style={{height: height}}>
			<Col>
				<Canvas>
					<OrbitControls autoRotate={true} />
					<Box />
				</Canvas>
			</Col>
			<Col>
				<Canvas>
					<OrbitControls autoRotate={true} />
					<Sphere />
				</Canvas>
			</Col>
		</Row>
	</>);
}

export default App;

function Box() {
	return (
		<mesh>
			<ambientLight intensity={0.5} />
			<directionalLight position={[-1,0,1]} intensity={0.5} />
			<boxGeometry args={[1, 1, 1]} />
			<meshStandardMaterial color={'orange'} />
		</mesh>
	);
}

function Sphere() {
	return (
		<mesh>
			<ambientLight intensity={0.95} />
			<directionalLight position={[-1,0,1]} intensity={0.5} />
			<sphereGeometry args={[2, 30, 30]} />
			<meshStandardMaterial color={'green'} />
		</mesh>
	);
}

function Torus() {
	const meshRef = useRef();
	const [color, setColor] = useState('#0000FF');

	useFrame(() => {
		if (meshRef.current) {
			meshRef.current.rotation.x += 0.01;
			meshRef.current.rotation.y += 0.01;
		}
	});

	useEffect(() => {
		const gui = new GUI();
		gui.addColor({ color }, 'color').onChange(setColor);
	}, []);
	

	return (
		<mesh ref={meshRef}>
			<ambientLight intensity={0.5} />
			<directionalLight position={[-1,0,1]} intensity={0.5} />
			<torusGeometry args={[2, 0.4, 16, 100]} />
			<meshStandardMaterial color={{color}} />
		</mesh>
	);
}
