import React, { useEffect, useLayoutEffect, useState } from "react";
import { Col, Row, } from "react-bootstrap";

// domain
import Panel from "../model/Panel";

// store
import store, { SCALE } from "../store/TestStore";

// view
import HouseView from "../view/HouseView";

const DEBUG: number = 0;
// TestContainer.tsx
const TestContainer = ((_: any) => {
	useEffect(() => {
		test();
	}, []);

	return (<>
		<BoxContainer
			show={true}
		/>
	</>);
});
export default TestContainer;

function test() {
	if (DEBUG !== 23) {
		return;
	}

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
}
function BoxContainer(props: any) {
	const { show } = props;
	const height: number = 1024;

	const [data, setData] = useState<Panel[]>([{
	            width: 2400,
	            height: 1200,
	            thick: 18,
	            pose: 0,
				x: 0,
				y: 0,
				z: 0,
	        }]);
	const [target, setTarget] = useState<any>({ x: 0, y: 0, z: 0, });
	const [position, setPosition] = useState<any>({
		x: 0,
		y: 0,
		z: 0,
	});

	useLayoutEffect(() => {
		window.addEventListener("keydown", handleOnKeydown, true);
	});
	useEffect(() => {
		setTarget({ x: 0, y: 0, z: 0, });
	}, [show, data]);

	function handleOnKeydown(event: KeyboardEvent) {
		event.stopImmediatePropagation();
		event.stopPropagation();

		const _refresh: boolean = store.testGeometryRotate(data, event.code);

		if (_refresh) {
			setData([...data]);
		}
	}
	function handleOnClickReset(event: React.MouseEvent<HTMLButtonElement>) {
		setTarget({ x: 0, y: 0, z: 0, });
		if (!event.shiftKey) {
			setPosition({ x: -3000 * SCALE, y: 1500 * SCALE, z: -5000 * SCALE, });
		}
	}

	if (!show) {
		return (<></>);
	}

	return (<>
		<Row className="mx-0 py-0 bg-dark text-white">
			<Col>
				<span className="btn btn-secondary btn-sm" onClick={handleOnClickReset}>
					Reset
				</span>
			</Col>
		</Row>
		<Row className="mx-0 py-0 bg-dark" style={{height: height}}>
			<Col>
				<HouseView
					target={target}
					position={position}
				/>
			</Col>
		</Row>
	</>);
}
