"
TODO
"
Class {
	#name : #RSAbstractTextAttribute,
	#superclass : #Object,
	#instVars : [
		'from',
		'to',
		'interactions'
	],
	#category : #'MooseIDE-AttributedText'
}

{ #category : #accessing }
RSAbstractTextAttribute >> endLine: aShape [
	^ self findLine: aShape index: to + 1
]

{ #category : #accessing }
RSAbstractTextAttribute >> findLine: aShape index: index [
	| lineNumber |
	lineNumber := 0.
	aShape model lineIndicesDo: [ :start :enddel :end |
		lineNumber := lineNumber +1.
		index <= end ifTrue: [ 
			| line |
			line := aShape shapes at: lineNumber.
			^ RSLineResult new
				lineNumber: lineNumber;
				start: start;
				end: end;
				index: index;
				line: line;
				point: (self pointFor: line at: index - start);
				yourself
			 ]
		 ].
	
	^ nil
		
		
]

{ #category : #accessing }
RSAbstractTextAttribute >> from [

	^ from
]

{ #category : #accessing }
RSAbstractTextAttribute >> from: anObject [

	from := anObject
]

{ #category : #initialization }
RSAbstractTextAttribute >> initialize [
	super initialize.
	interactions := Dictionary new
]

{ #category : #convenience }
RSAbstractTextAttribute >> on: anEvent do: aBlock [
	interactions at: anEvent put: aBlock 
]

{ #category : #accessing }
RSAbstractTextAttribute >> pointFor: label at: index [
	| rawExt cairoFont glyphs delta text |
	cairoFont := label cairoFont.
	glyphs := label cairoGlyphs.
	rawExt := CairoTextExtents new.
	text := label text.
	cairoFont getExtentsOfGlyphs: glyphs getHandle ofLength: index into: rawExt.
	
	delta := ((1 to: index-1) allSatisfy: [ :i | (text at: i) isSpaceSeparator ])
		ifTrue: [ rawExt width ]
		ifFalse: [ rawExt x_advance-rawExt x_bearing ].
	^ label encompassingRectangle bottomLeft + (delta	@0)
		
]

{ #category : #rendering }
RSAbstractTextAttribute >> renderIn: aShape [
	self subclassResponsibility
]

{ #category : #accessing }
RSAbstractTextAttribute >> startLine: aShape [
	^ self findLine: aShape index: from
]

{ #category : #accessing }
RSAbstractTextAttribute >> to [

	^ to
]

{ #category : #accessing }
RSAbstractTextAttribute >> to: anObject [

	to := anObject
]
