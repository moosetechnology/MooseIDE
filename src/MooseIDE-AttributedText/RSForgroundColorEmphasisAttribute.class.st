Class {
	#name : #RSForgroundColorEmphasisAttribute,
	#superclass : #RSAbstractTextAttribute,
	#instVars : [
		'color'
	],
	#category : #'MooseIDE-AttributedText'
}

{ #category : #accessing }
RSForgroundColorEmphasisAttribute >> color [

	^ color
]

{ #category : #accessing }
RSForgroundColorEmphasisAttribute >> color: anObject [

	color := anObject
]

{ #category : #rendering }
RSForgroundColorEmphasisAttribute >> renderIn: aShape [
	| startLine endLine label rect box |
	startLine := self startLine: aShape.
	endLine := self endLine: aShape.
	label := aShape shapes at: startLine lineNumber.
	rect := startLine point + (0@ label height negated) corner: endLine point.
	box := RSBox new
		paint: Color red;
		noBorder;
		fromRectangle: rect;
		yourself.
	aShape addShape: box.

]
