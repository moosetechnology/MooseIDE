"
I am the class responsible of building shapes for the distribution map.
"
Class {
	#name : #MiHDistributionMapStyle,
	#superclass : #HStyle,
	#traits : 'THWithCornerRadiusStyle',
	#classTraits : 'THWithCornerRadiusStyle classTrait',
	#category : #'MooseIDE-Dependency-DistributionMap'
}

{ #category : #hooks }
MiHDistributionMapStyle >> adjustLabel: aLabel ToWidth: width [

	| sizeOfNewText font text |
	font := aLabel font.
	text := aLabel text.
	aLabel textWidth > width ifFalse: [ ^ self ].
	sizeOfNewText := 1.
	[ (font widthOfString: text from: 1 to: sizeOfNewText) < width ] 
		whileTrue: [ sizeOfNewText := sizeOfNewText + 1 ].
	aLabel text: (text truncateTo: sizeOfNewText - 1),'.'
]

{ #category : #hooks }
MiHDistributionMapStyle >> buildCompositeEmptyNodeIn: shape [

	| node box rect |
	node := shape model.

	rect := shape children encompassingRectangle.
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

{ #category : #hooks }
MiHDistributionMapStyle >> buildCompositeFullNodeIn: shape [

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
		ifTrue: [ { children. title } ]
		ifFalse: [ { title. children } ].

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

{ #category : #hooks }
MiHDistributionMapStyle >> elementWidth [

	^ 10
]

{ #category : #hooks }
MiHDistributionMapStyle >> emptyBoxExtent [

	^ 30@20
]

{ #category : #hooks }
MiHDistributionMapStyle >> iconFor: anHNode [
	anHNode iconName ifNil: [ ^ nil ].
	^ RSBitmap new
		form: (self iconNamed: anHNode iconName);
		yourself.
		
]

{ #category : #hooks }
MiHDistributionMapStyle >> labelAndIconFor: anHNode [
	| group icon |
	group := RSGroup new.
	icon := self iconFor: anHNode.
	icon ifNotNil: [ group add: icon ].
	group add: (self labelFor: anHNode).
	
	RSHorizontalLineLayout new alignMiddle; on: group.
	^ group
]

{ #category : #hooks }
MiHDistributionMapStyle >> shapeFor: aHNode [

	| shape |
	shape := RSComposite new
		         model: aHNode;
		         yourself.
	aHNode level = 1
		ifTrue: [ self buildCompositeFullNodeIn: shape ]
		ifFalse: [ self buildCompositeEmptyNodeIn: shape ].

	^ shape
]
