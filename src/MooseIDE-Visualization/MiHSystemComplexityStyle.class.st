Class {
	#name : 'MiHSystemComplexityStyle',
	#superclass : 'HDefaultStyle',
	#category : 'MooseIDE-Visualization-System Complexity',
	#package : 'MooseIDE-Visualization',
	#tag : 'System Complexity'
}

{ #category : 'hooks' }
MiHSystemComplexityStyle >> borderFor: node [

	^ node hasChildren
		  ifTrue: [
				  RSBorder new
					  width: 2;
					  capSquare;
					  joinMiter;
					  color: Smalltalk ui theme textColor;
					  dashArray: #( 5 10 );
					  yourself ]
		  ifFalse: [
				  RSBorder new
					  color: Color black translucent;
					  yourself ]
]

{ #category : 'hooks' }
MiHSystemComplexityStyle >> buildCompositeEmptyNodeIn: shape [

	| node |
	node := shape model.
	node level <= 1 ifTrue: [
		| box |
		box := RSBox new
			       color: Color red;
			       yourself.
		shape color: Color transparent.
		box border: (self borderFor: node).

		shape propertyAt: #background put: box.
		shape add: (self labelAndIconFor: node) asShape.
		shape add: box.
		RSVerticalLineLayout on: shape children.
		shape schildren: #(  ).

		^ self ].


	super buildCompositeEmptyNodeIn: shape
]
