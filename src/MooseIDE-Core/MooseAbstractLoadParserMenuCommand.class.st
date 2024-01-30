Class {
	#name : #MooseAbstractLoadParserMenuCommand,
	#superclass : #MooseAbstractLoadModuleMenuCommand,
	#category : #'MooseIDE-Core-MenuBar'
}

{ #category : #accessing }
MooseAbstractLoadParserMenuCommand class >> label [

	^ 'Parser'
]

{ #category : #accessing }
MooseAbstractLoadParserMenuCommand class >> menuPriority [

	^ 30
]
