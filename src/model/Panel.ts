//	Panel.ts
export default interface Panel {
	id?: number;
	title?: string;
	description?: string;
	
	width: number;
	height: number;
	thick: number;
	
	pose: number;

	created?: string;
	updated?: string;

	// not support field. user custom.
	custom?: any;
}
