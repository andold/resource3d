import React, { useEffect, useRef, useState } from "react";
import { Col, Row, Button, } from "react-bootstrap";

import { TextureLoader } from "three";
import * as THREE from "three";
import { Vector3 } from "three";
import { Canvas, useFrame, useLoader } from "@react-three/fiber";
import { CameraControls, OrbitControls } from "@react-three/drei";

// domain
import Panel from "../model/Panel.ts";

// store
import store from "../store/TestStore.ts";

// view
import PanelView from "../view/PanelView.tsx";

// TestContainer.tsx
const TestContainer = ((props: any) => {
	useEffect(() => {
		let A = [
			[2, 3, 41],
			[5, 7, 43],
			[47, 53, 59]
		];
		let B = [
			[11, 13, 61],
			[17, 19, 67],
			[71, 73, 79]
		];
		let C = [
			[23, 29, 83],
			[31, 37, 89],
			[91, 97, 101]
		];
		let AB = store.multiply(A, B);
		let ABxC = store.multiply(AB, C);
		let BC = store.multiply(B, C);
		let AxBC = store.multiply(A, BC);
		console.log(A, B, C);
		console.log(ABxC);
		console.log(AxBC);
	}, []);

	console.log(props);
	return (<>
		<BoxContainer
			show={true}
		/>
	</>);
});
export default TestContainer;

function BoxContainer(props: any) {
	const { show } = props;
	const height: number = 1024;

	const cameraControlRef = useRef<CameraControls>(null);
	const [data, setData] = useState<Panel[]>([{
	            width: 240,
	            height: 120,
	            thick: 1.8,
	            pose: 0,
	        }]);

	useEffect(() => {
		cameraControlRef.current?.setTarget(0, 0, 0, true);
		window.addEventListener("keydown", handleOnKeydown, true);
	});

	function handleOnKeydown(event: KeyboardEvent) {
		if (!cameraControlRef.current) {
			return;
		}

		event.stopImmediatePropagation();
		event.stopPropagation();
		let p: Vector3 = new Vector3(0, 0, 0);
		cameraControlRef.current.getPosition(p);
		let t: Vector3 = new Vector3(0, 0, 0);
		cameraControlRef.current.getTarget(t);
		const dp = store.calculate(event.code, p, t);
		const _refresh: boolean = store.testGeometryRotate(data, event.code);
		console.log(dp, data);
		if (event.shiftKey) {
			cameraControlRef.current.setTarget(t.x + dp.x, t.y + dp.y, t.z + dp.z, true);
		} else {
			cameraControlRef.current.setPosition(p.x + dp.x, p.y + dp.y, p.z + dp.z, true);
		}
		if (_refresh) {
			setData([...data]);
		}
	}
	function handleOnClickReset(event: MouseEvent) {
		if (!cameraControlRef.current) {
			return;
		}
		cameraControlRef.current.setTarget(0, 0, 0);
		if (!event.shiftKey) {
			cameraControlRef.current.setPosition(-100, 100, -100, true);
		}
	}

	if (!show) {
		return (<></>);
	}

	return (<>
		<Row className="mx-0 py-0 bg-dark">
			<Col>
				<Button size="sm" variant="secondary" className="" onClick={handleOnClickReset}>Reset</Button>
			</Col>
		</Row>
		<Row className="mx-0 py-0 bg-dark" style={{height: height}}>
			<Col>
				<Canvas>
					<CameraControls ref={cameraControlRef} target={[0, 0, 0]} position={[-30, 30, -30]} />
					<OrbitControls autoRotate={true} />
					<Basis show={true} />
					<BoxMesh show={false} rotate={false} />
					{
						data.map((panel: any) => (
							<PanelView key={Math.random()} panel={panel}/>
						))
					} 
				</Canvas>
			</Col>
		</Row>
	</>);
}

function Basis(props: any) {
	const { show } = props;

	const v = [1000, 1, 1000];
	const texture = useLoader(TextureLoader, "/texture/인조화강암블럭.jpg");
	texture.wrapS = texture.wrapT = THREE.RepeatWrapping;
	texture.offset.set(0, 0);
	texture.repeat.set(64, 128);

	if (!show) {
		return (<></>);
	}

	return (<>
		<mesh position={[0, -v[1] / 2 , 0]}>
			<ambientLight intensity={1.0} />
			<directionalLight position={[-10,0,10]} intensity={1.0} />
			<boxGeometry args={v} />
			<meshStandardMaterial
				map={texture}
				opacity={0.9}
				transparent
			/>
		</mesh>
		<mesh position={[0, 0, 0]}>
			<boxGeometry args={[1, 1, 1]} />
			<meshStandardMaterial
				opacity={0.5}
				color={"red"}
				transparent
			/>
		</mesh>
		<mesh position={[100, 100, 100]}>
			<boxGeometry args={[1, 1, 1]} />
			<meshStandardMaterial
				opacity={0.5}
				color={"yellow"}
				transparent
			/>
		</mesh>
	</>);
}

function BoxMesh(props: any) {
	const { show, rotate } = props;
	
	const meshRef = useRef();
	useEffect(() => {
	}, []);
	useFrame(() => {
		if (meshRef.current && rotate) {
//			meshRef.current.rotation.x += 0.01;
//			meshRef.current.rotation.y += 0.01;
			meshRef.current.rotation.z += 0.01;
		}
	});
	
	if (!show) {
		return (<></>);
	}
	
	return (<>
		<mesh ref={meshRef} position={[0.5, 0.5, 0.5]}>
			<ambientLight intensity={1.0} />
			<directionalLight position={[-10,0,10]} intensity={1.0} />
			<boxGeometry args={[1, 1, 1]} />
			<meshStandardMaterial color={"orange"} />
		</mesh>
	</>);
}
