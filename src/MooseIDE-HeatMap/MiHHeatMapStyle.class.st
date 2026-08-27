Class {
	#name : 'MiHHeatMapStyle',
	#superclass : 'HStyle',
	#traits : 'THWithCornerRadiusStyle',
	#classTraits : 'THWithCornerRadiusStyle classTrait',
	#instVars : [
		'cornerRadius'
	],
	#category : 'MooseIDE-HeatMap',
	#package : 'MooseIDE-HeatMap'
}

{ #category : 'hooks' }
MiHHeatMapStyle >> adjustLabel: aLabel ToWidth: width [

	| sizeOfNewText font text |
	font := aLabel font.
	text := aLabel text.
	aLabel textWidth > width ifFalse: [ ^ self ].
	sizeOfNewText := 1.
	[ (font widthOfString: text from: 1 to: sizeOfNewText) < width ]
		whileTrue: [ sizeOfNewText := sizeOfNewText + 1 ].
	aLabel text: (text truncateTo: sizeOfNewText - 1) , '.'
]

{ #category : 'hooks' }
MiHHeatMapStyle >> buildCompositeEmptyNodeIn: shape [

	| node box |
	node := shape model.
	box := RSBox new
		       model: node;
		       width: self elementWidth;
		       height: self elementWidth;
		       color: (self colorFor: node);
		       border: (RSBorder new
				        width: 1;
				        capSquare;
				        joinMiter;
				        color: Smalltalk ui theme borderColor translucent;
				        yourself);
		       yourself.
	shape add: box.
	box pushBack.
	shape schildren: #(  ).

	shape propertyAt: #background put: box
]

{ #category : 'hooks' }
MiHHeatMapStyle >> buildCompositeFullNodeIn: shape [

	| childrenShapes node titleGroup title titleBox children boxChildren list |
	node := shape model.
	titleGroup := self labelAndIconFor: node.

	titleBox := RSBox new
		            extent: titleGroup extent;
		            color: Color transparent;
		            position: titleGroup position;
		            cornerRadius: self cornerRadius;
		            yourself.
	title := RSComposite new
		         add: titleBox;
		         addAll: titleGroup;
		         adjustToChildren;
		         yourself.
	shape propertyAt: #background put: titleBox.
	childrenShapes := node children collect: #asShape as: RSGroup.
	self layoutOn: childrenShapes parent: node.


	shape schildren: childrenShapes.
	childrenShapes do: [ :child | child sparent: shape ].
	children := childrenShapes asShape padding: 3.
	childrenShapes ifEmpty: [ children extent: self emptyBoxExtent ].
	childrenShapes do: [ :child | child model position: child position ].
	title width: children width.

	titleBox width: children width.
	self adjustLabel: (titleGroup at: 1) ToWidth: children width.

	boxChildren := RSBox new
		               color: Color transparent;
		               yourself.

	list := self titleLocation = #below
		        ifTrue: [
				        {
					        children.
					        title } ]
		        ifFalse: [
				        {
					        title.
					        children } ].

	RSVerticalLineLayout new
		gapSize: 0;
		on: list.

	boxChildren
		border: (RSBorder new
				 width: 1;
				 color: Smalltalk ui theme textColor;
				 yourself);
		fromRectangle: children encompassingRectangle.

	shape
		add: title;
		add: boxChildren;
		add: children.
	shape adjustToChildren
]

{ #category : 'hooks' }
MiHHeatMapStyle >> cornerRadius [

	^ cornerRadius ifNil: [
		  cornerRadius := RSCornerRadius new radius: self cornerRadiusValue ]
]

{ #category : 'accessing' }
MiHHeatMapStyle >> cornerRadiusValue [

	^ 7
]

{ #category : 'hooks' }
MiHHeatMapStyle >> elementWidth [

	^ 10
]

{ #category : 'hooks' }
MiHHeatMapStyle >> emptyBoxExtent [

	^ 30 @ 20
]

{ #category : 'hooks' }
MiHHeatMapStyle >> iconFor: anHNode [

	anHNode iconName ifNil: [ ^ nil ].
	^ RSBitmap new
		  form: (self iconNamed: anHNode iconName);
		  yourself
]

{ #category : 'hooks' }
MiHHeatMapStyle >> labelAndIconFor: anHNode [

	| group icon |
	group := RSGroup new.
	icon := self iconFor: anHNode.
	icon ifNotNil: [ group add: icon ].
	group add: (self labelFor: anHNode).

	RSHorizontalLineLayout new
		alignMiddle;
		on: group.
	^ group
]

{ #category : 'hooks' }
MiHHeatMapStyle >> shapeFor: aHNode [

	| shape |
	shape := RSComposite new
		         model: aHNode;
		         yourself.
	aHNode level = 1
		ifTrue: [ self buildCompositeFullNodeIn: shape ]
		ifFalse: [ self buildCompositeEmptyNodeIn: shape ].

	^ shape
]
