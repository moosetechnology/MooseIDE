Class {
	#name : #MiRSDependencyStructuralMatrix,
	#superclass : #RSDSM,
	#instVars : [
		'owner'
	],
	#category : #'MooseIDE-Dependency-DSM'
}

{ #category : #hooks }
MiRSDependencyStructuralMatrix >> createShape: tuple [

	| cell |
	cell := super createShape: tuple.
	cell
		when: RSMouseDoubleClick
		do: [ :evt | owner doubleClickOn: cell event: evt ]
		for: nil.
	^ cell
]

{ #category : #highlighting }
MiRSDependencyStructuralMatrix >> highlight: evt [
	super highlight: evt.
	"shape := nil."
	(owner sccShapesIncluding: evt shape) do: [ :aShape |
		aShape color: (owner cellShowSCCColor: aShape model)
	].

	"highlighting both labelsY"
	self paintLabelY: evt shape model key color: Color purple.
	self paintLabelY: evt shape model value color: Color purple

]

{ #category : #highlighting }
MiRSDependencyStructuralMatrix >> highlightRectangle: aGroupOfShapes key: key [
	"Highlighting creates rectangle shapes for the line and column
	 We need to set a MouseClickEvent on these rectangle because they 'hide' the cells below
	
	 - the rectangle shape is obtain from a property in the canvas 
	 - the cell from where the highlight originates is stored in #shape instance variable
	   (set in #highlight:)"

	super highlightRectangle: aGroupOfShapes key: key.

	(aGroupOfShapes anyOne canvas propertyAt: key) ifNotNil: [
		:rectangleShape |
		rectangleShape
			when: RSMouseDoubleClick
			do: [ :evt | owner doubleClickOn: shape event: evt ]
			for: nil ]
]

{ #category : #accessing }
MiRSDependencyStructuralMatrix >> owner: anObject [

	owner := anObject
]

{ #category : #highlighting }
MiRSDependencyStructuralMatrix >> paintLabelY: labelModel color: aColor [

	labelsY
		detect: [ :label | label model = labelModel ]
		ifOne: [ :label | label color: aColor ]

]

{ #category : #highlighting }
MiRSDependencyStructuralMatrix >> unhighlight: evt [
	super unhighlight: evt.

	(owner sccShapesIncluding: evt shape) do: [ :aShape |
		aShape color: (owner cellColor: aShape model)
	].

	self paintLabelY: evt shape model key color: Color black.
	self paintLabelY: evt shape model value color: Color black

]
