import React, { useEffect, } from "react";
import "katex/dist/katex.min.css";
import "./MathView.css";
import { InlineMath, BlockMath } from "react-katex";

// domain

// store

// view

const INDEXES = [0, 1, 2, "m", "n"];
const INDEX_TODAY = "n";
const trClass = "py-1";
const thClass = "px-2 py-1 fs-6 text-warning";
const thSpanClass = "px-0 bg-black text-warning";
const tdClass = "px-2 py-1";
const spanClass = "bg-black text-white";
const spanLargeClass = "bg-black text-white fs-5 py-1";
// MathView.tsx
const MathView = ((_: any) => {
	useEffect(() => {
	}, []);

	return (<>
		<h2>수익율</h2>
		<table className="table bg-black text-white" style={{ fontSize: "0.6rem" }}>
			<tr className="bg-secondary">
				<th className={thClass}>항목</th>
				<th className={thClass}>시작일</th>
				<th className={thClass}>시작일+1일</th>
				<th className={thClass}>시작일+2일</th>
				<th className={thClass}>시작일+m일</th>
				<th className={thClass}>오늘=시작일+n일</th>
			</tr>
			<tr className={trClass}>
				<th className={thClass}>입금</th>
				{INDEXES.map((item: any) => (<td className={tdClass}><span className={spanLargeClass}><Income index={item} /></span></td>))}
			</tr>
			<tr className={trClass}>
				<th className={thClass}>출금</th>
				{INDEXES.map((item: any) => (<td className={tdClass}><span className={spanLargeClass}><Outcome index={item} /></span></td>))}
			</tr>
			<tr className={trClass}>
				<th className={thClass}>평가</th>
				{INDEXES.map((item: any) => (<td className={tdClass}><span className={spanLargeClass}><InlineMath math={"평가_{" + item + "}"} /></span></td>))}
			</tr>
			<Principal comment={"원금"} />
			<Profit comment={"손익"} />
			<Ratio comment={"수익율"} />
		</table>
		<BlockMath math="평가_{오늘} = 평가_n = \sum_{i=0}^{n}{평가^{오늘}_i}" />
		<table className="table bg-black text-white" style={{ fontSize: "0.6rem" }}>
			<tr className="bg-secondary">
				<th className={thClass}>항목</th>
				<th className={thClass}>시작일</th>
				<th className={thClass}>시작일+1일</th>
				<th className={thClass}>시작일+2일</th>
				<th className={thClass}>시작일+m일</th>
				<th className={thClass}>오늘=시작일+n일</th>
			</tr>
			<Estimate comment={"평가"} />
		</table>
	</>);
});
export default MathView;

function Income(props: any) {
	return (<InlineMath math={"입금_{" + props.index + "}"} />);
}
function Outcome(props: any) {
	return (<InlineMath math={"출금_{" + props.index + "}"} />);
}
function Principal(_: any) {	//	원금
	return (<>
		<tr className={trClass}>
			<th className={thClass}>원금</th>
			{INDEXES.map((item: any) => (<td className={tdClass}><span className={spanClass}><InlineMath math={principal(item)} /></span></td>))}
		</tr>
		<tr className={trClass}>
			<th className={thClass}></th>
			{INDEXES.map((item: any) => (<td className={tdClass}><span className={spanClass}><InlineMath math={principal2(item)} /></span></td>))}
		</tr>
		<tr className={trClass}>
			<th className={thClass}><span className={thSpanClass}><InlineMath math="\small 원금^{누적}" /></span></th>
			{INDEXES.map((item: any) => (<td className={tdClass}><span className={spanClass}><InlineMath math={principals0(item)} /></span></td>))}
		</tr>
		<tr className={trClass}>
			<th className={thClass}></th>
			{INDEXES.map((item: any) => (<td className={tdClass}><span className={spanClass}><InlineMath math={principals1(item)} /></span></td>))}
		</tr>
		<tr className={trClass}>
			<th className={thClass}><span className={thSpanClass}><InlineMath math="\small 원금^{평균}" /></span></th>
			{INDEXES.map((item: any) => (<td className={tdClass}><span className={spanLargeClass}><InlineMath math={principalm0(item)} /></span></td>))}
		</tr>
	</>);
}
function principal(index: any): string {	//	원금
	if (index === 0) {
		return "입금_0 - 출금_0";
	}

	return "\\displaystyle \\sum_{i=0}^{" + index + "} ({입금_i - 출금_i})";
}
function principal2(index: any): string {	//	원금
	if (index === 0) {
		return "입금_0 - 출금_0";
	}
	if (index === 1) {
		return "원금_{0} + (입금_1 - 출금_1)";
	}
	if (Number.isFinite(index)) {
		return "원금_{" + (index - 1) + "} + ({입금_{" + index + "} - 출금_{" + index + "}})";
	}

	return "원금_{" + index + "-1} + ({입금_{" + index + "} - 출금_{" + index + "}})";
}
function principals0(index: any): string {	//	원금^{누적}
	if (index === 0) {
		return "원금_0";
	}
	if (index === 1) {
		return "\원금_{0} + 원금_{1}";
	}
	if (index === 2) {
		return "\원금_{0} + 원금_{1} + 원금_{2}";
	}

	return "\\displaystyle \\sum_{i=0}^{" + index + "}{원금_{" + (index) + "}}";
}
function principals1(index: any): string {	//	원금^{누적}
	if (index === 0) {
		return "원금_0";
	}
	if (index === 1) {
		return "\원금^{누적}_{0} + 원금_{1}";
	}
	if (Number.isFinite(index)) {
		return "\원금^{누적}_{" + (index - 1) + "} + 원금_{" + (index) + "}";
	}

	return "\원금^{누적}_{" + (index) + " - 1} + 원금_{" + (index) + "}";
	return "\\frac{\\displaystyle \\sum_{i=0}^{" + index + "}{원금_i}}{" + (index) + " + 1}";
}
function principalm0(index: any): string {	//	평균원금
	if (index === 0) {
		return "원금^{누적}_{" + (index) + "}";
	}
	if (Number.isFinite(index)) {
		return "\\frac{" + "원금^{누적}_{" + (index) + "}}{" + (index + 1) + "}";
	}

	return "\\frac{" + "원금^{누적}_{" + (index) + "}}{" + (index) + " + 1}";
}

function Profit(_: any) {	//	손익
	return (<>
		<tr className={trClass}>
			<th className={thClass}>손익</th>
			{INDEXES.map((item: any) => (<td className={tdClass}><span className={spanClass}><InlineMath math={"평가_{" + item + "} - 원금_{" + item + "}"} /></span></td>))}
		</tr>
		<tr className={trClass}>
			<th className={thClass}><span className={thSpanClass}><InlineMath math="\small 손익^{누적}" /></span></th>
			{INDEXES.map((item: any) => (<td className={tdClass}><span className={spanClass}><InlineMath math={profits0(item)} /></span></td>))}
		</tr>
		<tr className={trClass}>
			<th className={thClass}><span className={thSpanClass}></span></th>
			{INDEXES.map((item: any) => (<td className={tdClass}><span className={spanClass}><InlineMath math={profits1(item)} /></span></td>))}
		</tr>
		<tr className={trClass}>
			<th className={thClass}><span className={thSpanClass}><InlineMath math="\small 손익^{평균}" /></span></th>
			{INDEXES.map((item: any) => (<td className={tdClass}><span className={spanLargeClass}><InlineMath math={profitm0(item)} /></span></td>))}
		</tr>
	</>);
}
function profits1(index: any): string {	//	손익S
	if (index === 0) {
		return "손익_{0}";
	}
	if (index === 1) {
		return "손익^{누적}_{0} + 손익_{1}";
	}
	if (index === 2) {
		return "손익^{누적}_{1} + 손익_{2}";
	}
	if (Number.isFinite(index)) {
		return "손익^{누적}_{" + (index - 1) + "} + 손익_{" + (index) + "}";
	}

	return "손익^{누적}_{" + (index) + "-1} + 손익_{" + (index) + "}";
}
function profits0(index: any): string {	//	손익S
	if (index === 0) {
		return "손익_{0}";
	}
	if (index === 1) {
		return "손익_{0} + 손익_{1}";
	}
	if (index === 2) {
		return "손익_{0} + 손익_{1} + 손익_{2}";
	}
	if (Number.isFinite(index)) {
		return "\\displaystyle \\sum_{i=0}^{" + (index) + "}{손익_{i}}";
	}

	return "\\displaystyle \\sum_{i=0}^{" + (index) + "}{손익_{i}}";
}
function profitm0(index: any): string {	//	평균손익M
	if (index === 0) {
		return "손익^{누적}_{0}";
	}
	if (index === 1) {
		return "\\frac{손익^{누적}_{1}}{2}";
	}
	if (index === 2) {
		return "\\frac{손익^{누적}_{2}}{3}";
	}
	if (Number.isFinite(index)) {
		return "\\frac{손익^{누적}_{" + (index) + "}}}{" + (index + 1) + "}";
	}

	return "\\frac{손익^{누적}_{" + (index) + "}}{" + (index) + "+1}";
}

function Estimate(_: any) {	//	평가
	return (<>
		<tr className={trClass}>
			<th className={thClass + " py-2"}><span className={thSpanClass}><InlineMath math="\small 평가^{오늘}" /></span></th>
			{INDEXES.map((item: any) => (<td className={tdClass}><span className={spanClass}><InlineMath math={estimatet0(item)} /></span></td>))}
		</tr>
		<tr className={trClass}>
			<th className={thClass}><span className={thSpanClass}><InlineMath math="\small 평가^{오늘 누적}" /></span></th>
			{INDEXES.map((item: any) => (<td className={tdClass}><span className={spanClass}><InlineMath math={estimatets0(item)} /></span></td>))}
		</tr>
		<tr className={trClass}>
			<th className={thClass}></th>
			{INDEXES.map((item: any) => (<td className={tdClass}><span className={spanLargeClass}><InlineMath math={estimatets1(item)} /></span></td>))}
		</tr>
	</>);
}
function estimatet0(index: any): string {	//	평가^{오늘}
	if (index === 0) {
		return "원금_" + index + "(1 + 수익율^{오늘})^{" + INDEX_TODAY + "} - 원금_{0}";
	}
	if (Number.isFinite(index)) {
		return "원금_" + index + "(1 + 수익율^{오늘})^{" + INDEX_TODAY + "-" + index + "} - 원금_{" + index + "}";
	}
	if (index === INDEX_TODAY) {
		return "0";
	}

	return "원금_" + index + "(1 + 수익율^{오늘})^{" + INDEX_TODAY + "-" + index + "} - 원금_{" + index + "}";
}
function estimatets0(index: any): string {	//	평가^{오늘누적}
	if (index === 0) {
		return "평가^{오늘}_{" + index + "}";
	}
	if (index === 1) {
		return "평가^{오늘}_{" + (index - 1) + "} + 평가^{오늘}_{" + index + "}";
	}
	if (index === 2) {
		return "평가^{오늘}_{" + (index - 2) + "} + 평가^{오늘}_{" + (index - 1) + "} + 평가^{오늘}_{" + index + "}";
	}

	return "\\displaystyle \\sum_{i=0}^{" + (index) + "}{평가^{오늘}_{i}}";
}
function estimatets1(index: any): string {	//	평가^{오늘누적}
	if (index === INDEX_TODAY) {
		return "손익_{" + index + "}";
	}

	return "-";
}

function Ratio(_: any) {
	return (<>
		<tr className={trClass}>
			<th className={thClass}>수익율</th>
			{INDEXES.map((item: any) => (<td className={tdClass}><span className={spanLargeClass}><InlineMath math={ratio0(item)} /></span></td>))}
		</tr>
		<tr className={trClass}>
			<th className={thClass}><span className={thSpanClass}><InlineMath math="\small 수익율^{평균}" /></span></th>
			{INDEXES.map((item: any) => (<td className={tdClass}><span className={spanLargeClass}><InlineMath math={ratiom0(item)} /></span></td>))}
		</tr>
		<tr className={trClass}>
			<th className={thClass}><span className={thSpanClass}><InlineMath math="\tiny = 수익율^{누적}" /></span></th>
			{INDEXES.map((item: any) => (<td className={tdClass}><span className={spanLargeClass}><InlineMath math={ratiom1(item)} /></span></td>))}
		</tr>
	</>);
}
function ratio0(index: any): string {	//	수익율
	return "\\frac{손익_{" + (index) + "}}{원금_{" + (index) + "}}";
}
function ratiom0(index: any): string {	//	수익율^{평균}
	return "\\frac{손익^{평균}_{" + (index) + "}}{원금^{평균}_{" + (index) + "}}";
}
function ratiom1(index: any): string {	//	수익율^{평균}
	return "\\frac{손익^{누적}_{" + (index) + "}}{원금^{누적}_{" + (index) + "}}";
}
