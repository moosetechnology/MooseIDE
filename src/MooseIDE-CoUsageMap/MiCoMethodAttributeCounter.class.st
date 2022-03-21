"
Used to obtain a list of inner models and their number of uses on the current method.
"
Class {
	#name : #MiCoMethodAttributeCounter,
	#superclass : #Object,
	#category : #'MooseIDE-CoUsageMap-Model'
}

{ #category : #public }
MiCoMethodAttributeCounter >> allAttributesFor: aMiCoMethod [
	"should return a list of associations(a Bag), for each association:
	key is the object
	value is the number of uses of that object is used by aMiCoMethod"
	^ self subclassResponsibility
]
