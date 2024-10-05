"
For FamixStEntities the StSourceAnchor contains very little information and the sourceText comes from the entity itself
"
Class {
	#name : #MiSourceTextStAnchorAdapter,
	#superclass : #MiAbstractSourceTextAnchorAdapter,
	#category : #'MooseIDE-Famix-SourceText'
}

{ #category : #'as yet unclassified' }
MiSourceTextStAnchorAdapter class >> acceptedEntities [

	^{ FamixStClass . FamixStMethod }
]

{ #category : #'as yet unclassified' }
MiSourceTextStAnchorAdapter >> intervalForEntity: anEntity [
	"Finding the interval for the entity relies on double dispatching because
	 the displayedText is generated differently for each entity (mainly classes and methods)"

	(super intervalForEntity: anEntity)
		ifNotNil: [ :interval | ^interval ].

	^anEntity accept: self
]

{ #category : #'as yet unclassified' }
MiSourceTextStAnchorAdapter >> visitFamixStAttribute: anAttribute [

	^nil
]

{ #category : #'as yet unclassified' }
MiSourceTextStAnchorAdapter >> visitFamixStClass: aClass [
	"if we are here it is because the class is not the main displayed entity
	 Therefore it's an error"

	Error signal: aClass name , ' is not the displayed entity'

]

{ #category : #'as yet unclassified' }
MiSourceTextStAnchorAdapter >> visitFamixStComment: aComment [
	"might be a class comeent or a method comment.
	 In bothe cases we should alread have the commented entity's interval in the cache
	 Then look for the comment interval within this entity's interval"

	| startPos entityInterval |

	entityInterval := entitiesIntervals
		at: aComment commentedEntity
		ifAbsent: [ ^nil ].

	startPos := self displayedText findString: aComment content startingAt: entityInterval first.
	^(startPos = 0)
		ifTrue: [ Error signal: aComment name , ' not found in displayed entity'
 ]
		ifFalse: [ Interval from: startPos to: (startPos + aComment content size)]
]

{ #category : #'as yet unclassified' }
MiSourceTextStAnchorAdapter >> visitFamixStImplicitVariable: aLocalVariable [

	^nil
]

{ #category : #'as yet unclassified' }
MiSourceTextStAnchorAdapter >> visitFamixStLocalVariable: aLocalVariable [

	^nil
]

{ #category : #'as yet unclassified' }
MiSourceTextStAnchorAdapter >> visitFamixStMethod: aMethod [
	"if we are here it is because the method is not the main displayed entity
	 So we must assume, its class is and we are looking for the text of the method within
	 the generated text of its parentClass"

	| startPos |
	self assert: (entitiesIntervals keys includes: aMethod parentType).

	startPos := self displayedText findString: aMethod displayedNameInMiSourceText startingAt: 1.
	^(startPos = 0)
		ifTrue: [ Error signal: aMethod name , ' not found in displayed entity'
 ]
		ifFalse: [ Interval from: startPos to: (startPos + aMethod sourceText size)]
]
