import React, { useEffect, useState } from "react";

import * as THREE from "three";
import { Euler, TextureLoader, Vector3 } from "three";
import { useLoader } from "@react-three/fiber";
import { Text } from "@react-three/drei";

// domain
import Panel from "../model/Panel";

// store
import store, { SCALE } from "../store/TestStore";

// view

// WallView.tsx
const WallView = ((props: any) => {
	const wall: Panel = props.wall;
	
	const [position, setPosition] = useState<Vector3>();
	const [rotation, setRotation] = useState<Euler|undefined>();
	useEffect(() => {
		const p: Vector3 = store.position(wall);
		setPosition(p);
		const r: Euler = store.rotation(wall);
		setRotation(r);
	}, [wall]);

	const texture = useLoader(TextureLoader, "/texture/자작나무.jpg");
	texture.wrapS = texture.wrapT = THREE.RepeatWrapping;
	texture.offset.set(0, 0.5);
	texture.repeat.set(1, 1);

	if (!position) {
		return (<></>);
	}

	return (<>
		<mesh position={store.scaleVector3(position, wall)} rotation={rotation}>
			<boxGeometry args={store.scaleGeometry(wall)} />
			<meshStandardMaterial
				color={"#F0F0F0"}
				opacity={0.5}
				transparent
			/>
			<Information
				panel={wall}
				show={true}
			/>
		</mesh>
	</>);
});
export default WallView;

function Information(props: any) {
	const { show } = props;
	const panel: Panel = props.panel;
	const FONT_SIZE = 1;

	if (!show) {
		return (<></>);
	}

	return (<>
		<Text
			fontSize={FONT_SIZE}
			textAlign={"left"}
			anchorX={"left"}
			anchorY={"top"}
			outlineWidth={0.1}
			outlineOffsetX={0.1}
			outlineOffsetY={0.1}
			position-x={panel.width / -2 + FONT_SIZE / 2}
			position-y={panel.thick / 2 + SCALE / 100}
			position-z={panel.height / -2}
			rotation={new Euler(-Math.PI / 2, 0, 0)}
		>
			<meshStandardMaterial color={"yellow"} />
			{panel.width * SCALE}㎜ x {panel.height * SCALE}㎜ x {panel.thick * SCALE}㎜
			({panel.x}, {panel.y}, {panel.z})
	    </Text>
	</>);
}
