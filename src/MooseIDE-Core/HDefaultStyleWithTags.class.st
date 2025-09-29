"
This style shows tags on nodes.
"
Class {
	#name : #HDefaultStyleWithTags,
	#superclass : #HDefaultStyle,
	#category : #'MooseIDE-Core-Hierarchical'
}

{ #category : #hooks }
HDefaultStyleWithTags >> labelAndIconFor: node [

	| group entity |
	group := super labelAndIconFor: node.
	entity := node rawModel.
	(entity isNotNil and: [ entity isTag not and: [ entity isTagged ] ])
		ifTrue: [
				entity tags do: [ :tag |
						group addFirst: (RSCircle new
								 color: tag color;
								 radius: 7;
								 yourself) ] ].
	node children ifNotEmpty: [
		(self tagIconFor: node) ifNotNil: [ :icon | group addLast: icon ] ].
	RSHorizontalLineLayout new
		alignMiddle;
		on: group.
	^ group
]

{ #category : #hooks }
HDefaultStyleWithTags >> tagIconFor: node [
	"We could just do a #flatCollectAsSet: of the tags on the #allChildren but this can be pretty long to do. And in the end we just want to know if there is 0, 1 or multiple tags so here is an optimized version.
	
	We optimize because we want to avoid to go to the deepest children when we find tags on upper levels and we also want to avoid collecting all possbile tags when the first children already have some.
	This is ugly code but that improves quite a bit the vizualization speed.
	
	It could be simpler doing: 
	
		| tags |
		tags := node allChildren flatCollectAsSet: [ :childNode | childNode rawModel tags ].
		tags size = 1 ifTrue: [
			^(RSBox new
					 color: tags anyOne color;
					 size: 14;
					 yourself) ].
		tags size > 1 ifTrue: [ ^ self createMultiTagBox ].
		
		^ nil"

	| childrenToCheck foundTag lookupBlock |
	lookupBlock := [ :entity |
	               entity tags ifNotEmpty: [ :tags |
		               tags size = 1
			               ifTrue: [
				               foundTag
					               ifNil: [ foundTag := tags anyOne ]
					               ifNotNil: [ "We have multiple tags in the found one is different than the currently found tag"
					               foundTag = tags anyOne ifFalse: [ ^ self createMultiTagBox ] ] ]
			               ifFalse: [ ^ self createMultiTagBox ] ] ].

	childrenToCheck := node children.

	[ childrenToCheck isEmpty ] whileFalse: [
		childrenToCheck do: [ :childNode | lookupBlock value: childNode rawModel ].
		childrenToCheck := childrenToCheck flatCollect: #children ].

	^ foundTag ifNotNil: [
		  ^ RSBox new
			    color: foundTag color;
			    size: 14;
			    yourself ]
]
