Class {
	#name : #FamixCBViolationGroup,
	#superclass : #MooseSpecializedGroup,
	#category : #'Famix-CriticBrowser-Entities-Group'
}

{ #category : #accessing }
FamixCBViolationGroup >> allEntities [
	^ (self collect: [ :each | each violatingEntity ]) asMooseGroup
]

{ #category : #'as yet unclassified' }
FamixCBViolationGroup >> allViolatingEntitiesType [
"returns all the different types of the violating entities"
	^ self collectAsSet: [ :each | each violatingEntity class ]
	
]

{ #category : #'as yet unclassified' }
FamixCBViolationGroup >> allWithViolatingEntitiesType: aType [
"returns every violation whose entity is of type aType"
	^ self select: [ :violation | violation violatingEntity class = aType ]
]

{ #category : #naming }
FamixCBViolationGroup >> stringForCBDescription [
"returns a string fitting for a description used in the model critic browser"
	^ String streamContents: [ :s | 
		  | typeName |
		  typeName := self allViolatingEntitiesType size = 1 
				ifTrue: [ self entities anyOne violatingEntity mooseDescription name ]
				ifFalse: [ 'entity' ].
		  s
			  print: self size;
			  space;
		  << (self size > 1
				   ifTrue: [ typeName asEnglishPlural ]
				   ifFalse: [ typeName ]) ] 
]
