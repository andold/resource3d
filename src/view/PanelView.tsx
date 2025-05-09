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

// PanelView.tsx
const PanelView = ((props: any) => {
	const panel: Panel = props.panel;
	
	const [position, setPosition] = useState<Vector3>();
	const [rotation, setRotation] = useState<Euler>();
	useEffect(() => {
		const p: Vector3 = store.position(panel);
		setPosition(p);
		const r: Euler = store.rotation(panel);
		setRotation(r);
	}, [panel]);

	const texture = useLoader(TextureLoader, "/texture/자작나무.jpg");
	texture.wrapS = texture.wrapT = THREE.RepeatWrapping;
	texture.offset.set(0, 0.5);
	texture.repeat.set(1, 1);

	//console.log(panel, position);

	if (!position) {
		return (<></>);
	}

	return (<>
		<mesh position={store.scaleVector3(position, panel)} rotation={rotation}>
			<boxGeometry args={store.scaleGeometry(panel)} />
			<meshStandardMaterial
				map={texture}
				opacity={0.9}
				transparent
			/>
			<Information
				panel={panel}
				show={true}
			/>
		</mesh>
	</>);
});
export default PanelView;

function Information(props: any) {
	const { show } = props;
	const panel: Panel = props.panel;
	const FONT_SIZE = 0.05;

	const [position, setPosition] = useState<Vector3>();
	useEffect(() => {
		const before = new Vector3(panel.width / -2 + FONT_SIZE, panel.thick / 2 + SCALE * 100, panel.height / -2);
		const p: Vector3 = store.scaleVector3(before);
		setPosition(p);
	}, [panel]);

	if (!show) {
		return (<></>);
	}

	return (<>
		<Text
			//font={"나눔고딕"}
			fontSize={FONT_SIZE}
			textAlign={"left"}
			anchorX={"left"}
			anchorY={"top"}
			outlineWidth={FONT_SIZE / 10}
			outlineOffsetX={FONT_SIZE / 20}
			outlineOffsetY={FONT_SIZE / 20}
			position-x={position?.x}
			position-y={position?.y}
			position-z={position?.z}
			rotation={new Euler(-Math.PI / 2, 0, 0)}
		>
			<meshStandardMaterial color={"yellow"} />
			{panel.width}㎜ x {panel.height}㎜ x {panel.thick}㎜
			({panel.x}, {panel.y}, {panel.z})
	    </Text>
	</>);
}
