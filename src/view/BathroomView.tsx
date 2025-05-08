import React, { useEffect, useState } from "react";

// domain
import Panel from "../model/Panel";

// store

// view
import WallView from "../view/WallView";

// BathroomView.tsx
const BathroomView = ((_: any) => {
	const [data, setData] = useState<Panel[]>([]);
	useEffect(() => {
		setData(outter({
            width: 4700,
            height: 1990,
            thick: 100,
            pose: 0,
			x: 0,
			y: 0,
			z: 0,
        }));
	}, []);

	return (<>{
		data.map((wall: any) => (
			<WallView key={Math.random()} wall={wall}/>
		))
	}</>);
});
export default BathroomView;


function outter(p: Panel): Panel[] {
	const walls: Panel[] = [];
	const height: number = 3000;	//	층고
	walls.push({	//	바닥
		width: p.width + p.thick * 2,
		height: p.height + p.thick * 2,
		thick: p.thick,
		pose: 0,
		x: -p.thick,
		y: -p.thick + 1,
		z: -p.thick,
	});
	/*
	walls.push({	//	천정
		width: p.width + p.thick * 2,
		height: p.height + p.thick * 2,
		thick: p.thick,
		pose: 0,
		x: -p.thick,
		y: height - 1,
		z: -p.thick,
	});
	walls.push({	//	측면11
		width: p.width + p.thick * 1,
		height: height,
		thick: p.thick,
		pose: 4,
		x: -p.thick,
		y: 0,
		z: -p.thick,
	});
	*/
	walls.push({	//	측면12
		width: p.width + p.thick * 1,
		height: height,
		thick: p.thick,
		pose: 4,
		x: 0,
		y: 0,
		z: p.height,
	});
	walls.push({	//	측면21
		width: p.height + p.thick * 1,
		height: height,
		thick: p.thick,
		pose: 5,
		x: -p.thick,
		y: 0,
		z: -p.thick,
	});
	walls.push({	//	측면21
		width: p.height + p.thick * 1,
		height: height,
		thick: p.thick,
		pose: 5,
		x: p.width,
		y: 0,
		z: 0,
	});
	return walls;
}
