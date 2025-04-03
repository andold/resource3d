//	Panel.ts
interface Size {
	width: number;
	height: number;
	thick: number;
}
interface Position {
	x?: number;
	y?: number;
	z?: number;
}
export default interface Panel extends Size, Position {
	id?: number;
	title?: string;
	description?: string;
	
	pose: number;

	created?: string;
	updated?: string;

	// not support field. user custom.
	custom?: any;
}
