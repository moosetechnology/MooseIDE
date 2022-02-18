"
Default class used by MiCoUsageMapBuilder. It works with pharo methods.
associationsFor: recives one method and return a list of associations, where the key of one association is the attribute and the valuee is the number of uses of that attribute in the method
"
Class {
	#name : #MiCoPharoMethodAttributeTester,
	#superclass : #MiCoMethodAttributeTester,
	#category : #'MooseIDE-CoUsageMap-Model'
}

{ #category : #'as yet unclassified' }
MiCoPharoMethodAttributeTester >> numberOfUsesOf: aMiCoAttribute on: aMiCoMethod [
	| name method result |
	name := aMiCoAttribute name.
	method := aMiCoMethod rawObject.
	result := RBGenericNodeVisitor
		visit: method ast
		select: [ :node| node isInstanceVariable and: [ node name = name ] ].
		
	^ result size
]
