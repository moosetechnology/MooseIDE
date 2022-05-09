"
Default class used by MiCoUsageMapBuilder. It works with pharo methods.
associationsFor: recives one method and return a list of associations, where the key of one association is the attribute and the valuee is the number of uses of that attribute in the method
"
Class {
	#name : #MiCoPharoMethodAttributeCounter,
	#superclass : #MiCoMethodAttributeCounter,
	#category : #'MooseIDE-CoUsageMap-Model'
}

{ #category : #public }
MiCoPharoMethodAttributeCounter >> allAttributesFor: aMiCoMethod [
	| method result |
	method := aMiCoMethod rawObject.
	result := RBGenericNodeVisitor
		visit: method ast
		select: [ :node| node isInstanceVariable ].
	^ result collect: [:node | node name ]
]
