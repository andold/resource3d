import React, { useEffect, } from "react";

// domain

// store

// view
import MathView from "../view/MathView";

// MathContainer.tsx
const MathContainer = ((_: any) => {
	useEffect(() => {
	}, []);

	return (<>
		<div className="bg-black text-white">
			<MathView
			/>
		</div>
	</>);
});
export default MathContainer;
