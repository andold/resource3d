import "./App.css";
import "bootstrap/dist/css/bootstrap.min.css";
import { useLayoutEffect, } from "react";

// container
import TestContainer from "./container/TestContainer";
import MathContainer from "./container/MathContainer";

function App() {
	useLayoutEffect(() => {
		document.title = "resource3d #3d #creality #3d-printer";
	}, []);

	return (<>
		<MathContainer />
		<TestContainer/>
	</>);
}

export default App;
