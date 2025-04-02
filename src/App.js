import "./App.css";
import "bootstrap/dist/css/bootstrap.min.css";
import { useLayoutEffect, } from "react";

// container
import TestContainer from "./container/TestContainer.tsx";

function App() {
	useLayoutEffect(() => {
		document.title = "resource3d #3d #creality #3d-printer";
	}, []);

	return (<>
		<TestContainer/>
	</>);
}

export default App;
