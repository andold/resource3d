import React, { useEffect, useState } from "react";

import * as THREE from "three";
import { Euler, TextureLoader, Vector3 } from "three";
import { useLoader } from "@react-three/fiber";
import { Text } from "@react-three/drei";

// domain
import Panel from "../model/Panel";

// store
import store from "../store/TestStore";

// view

const SCALE: number = 10;

// PanelView.tsx
const PanelView = ((props: any) => {
	const panel: Panel = props.panel;
	
	const [position, setPosition] = useState<Vector3>();
	useEffect(() => {
		const p: Vector3 = store.position(panel);
		setPosition(p);
	}, [panel]);

	const texture = useLoader(TextureLoader, "/texture/자작나무.jpg");
	texture.wrapS = texture.wrapT = THREE.RepeatWrapping;
	texture.offset.set( 0, 0.5 );
	texture.repeat.set(1, 1);

	//console.log(panel, position);

	if (!position) {
		return (<></>);
	}

	return (<>
		<mesh position={position} rotation={store.rotation(panel)}>
			<boxGeometry args={[panel.width, panel.thick, panel.height]} />
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
	const FONT_SIZE = 4;

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
