import React, { useEffect, useRef, useState } from "react";
import * as THREE from "three";
import { TextureLoader } from "three";
import { Canvas, useFrame, useLoader } from "@react-three/fiber";
import { CameraControls, OrbitControls } from "@react-three/drei";

// domain
import Panel from "../model/Panel";

// store

// view
import PanelView from "../view/PanelView";
import BathroomView from "../view/BathroomView";

// HouseView.tsx
const HouseView = ((props: any) => {
	const { target, position } = props;

	const cameraControlRef = useRef<CameraControls>(null);
	const [data] = useState<Panel[]>([{
	            width: 2400,
	            height: 1200,
	            thick: 18,
	            pose: 0,
				x: -2400 - 1000,
				y: 0,
				z: -1200 - 1000,
	        }]);

	useEffect(() => {
		if (!cameraControlRef.current || !target || !position) {
			return;
		}

		cameraControlRef.current.setTarget(target.x, target.y, target.z, true);
		cameraControlRef.current.setPosition(position.x, position.y, position.z, true);
	}, [target, position]);

	return (<>
		<Canvas>
			<CameraControls ref={cameraControlRef} distance={30} />
			<OrbitControls autoRotate={true} />
			<Basis show={!!true} />
			<BoxMesh show={false} rotate={false} />
			{
				data.map((panel: any) => (
					<PanelView key={Math.random()} panel={panel}/>
				))
			} 
			<BathroomView />
		</Canvas>
	</>);
});
export default HouseView;

function Basis(props: any) {
	const { show } = props;

	const v: any[] = [1000, 0.1, 1000];
	const texture = useLoader(TextureLoader, "/texture/잔디.png");
	texture.wrapS = texture.wrapT = THREE.RepeatWrapping;
	texture.offset.set(0, 0);
	texture.repeat.set(128, 128);

	if (!show) {
		return (<>
			<mesh position={[0, 0, 0]}>
				<boxGeometry args={[0.001, 0.001, 0.001]} />
				<meshStandardMaterial
					opacity={0.95}
					color={"red"}
					transparent
				/>
			</mesh>
			<mesh position={[10, 10, 10]}>
				<boxGeometry args={[1, 1, 1]} />
				<meshStandardMaterial
					opacity={0.5}
					color={"yellow"}
					transparent
				/>
			</mesh>
		</>);
	}

	return (<>
		<mesh position={[0, -v[1] / 2 , 0]}>
			<ambientLight intensity={1.0} />
			<directionalLight position={[-10,0,10]} intensity={1.0} />
			<boxGeometry args={[v[0], v[1], v[2]]} />
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
	
	const meshRef = useRef<any>(null);
	useEffect(() => {
	}, []);
	useFrame(() => {
		if (meshRef.current && rotate) {
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
