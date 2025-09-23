"
TODO
"
Class {
	#name : #RSLinkEmphasisAttribute,
	#superclass : #RSAbstractTextAttribute,
	#category : #'MooseIDE-AttributedText'
}

{ #category : #rendering }
RSLinkEmphasisAttribute >> renderIn: aShape [
	| startLine endLine line label rect box |
	startLine := self startLine: aShape.
	endLine := self endLine: aShape.
	line := RSLine new
		startPoint: startLine point;
		endPoint: endLine point;
		color: Color black;
		width: 1;
		yourself.
	aShape addShape: line.
	label := aShape shapes at: startLine lineNumber.
	rect := startLine point + (0@ label height negated) corner: endLine point.
	box := RSBox new
		noPaint;
		noBorder;
		fromRectangle: rect;
		flag: #'TODO - highlightling lines can use RSHighlightable';
		when: RSMouseEnter do: [ :evt | line width: 3; signalUpdate ];
		when: RSMouseLeave do: [ :evt | line width: 1; signalUpdate ];
		yourself.
	aShape addShape: box.

	interactions keysAndValuesDo: [ :event : action | box when: event do: action ].
]
