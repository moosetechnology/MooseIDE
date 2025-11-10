"
An abstract super-class for various strategies to compute children boxes of a container box
"
Class {
	#name : 'MiCoInnerEntitiesAbstractExtractor',
	#superclass : 'Object',
	#category : 'MooseIDE-CoUsageMap-Model',
	#package : 'MooseIDE-CoUsageMap',
	#tag : 'Model'
}

{ #category : 'accessing' }
MiCoInnerEntitiesAbstractExtractor class >> description [

	self subclassResponsibility 
]

{ #category : 'accessing' }
MiCoInnerEntitiesAbstractExtractor class >> menuItemName [

	self subclassResponsibility 
]

{ #category : 'execute' }
MiCoInnerEntitiesAbstractExtractor >> innerEntitiesFor: containerBox [

	self subclassResponsibility 
]
