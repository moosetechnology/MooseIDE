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
MiCoPharoMethodAttributeCounter >> associationsListIn: aMiCoMethod [
	| bag method result |
	method := aMiCoMethod rawObject.
	bag := Bag new.
	result := RBGenericNodeVisitor
		visit: method ast
		select: [ :node| node isInstanceVariable ].
	bag addAll: (result collect: [:node | node name ]).
	^ bag valuesAndCounts associations
]
