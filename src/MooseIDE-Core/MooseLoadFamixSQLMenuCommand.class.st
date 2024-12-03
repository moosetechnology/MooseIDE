Class {
	#name : #MooseLoadFamixSQLMenuCommand,
	#superclass : #MooseAbstractLoadFamixMenuCommand,
	#category : #'MooseIDE-Core-MenuBar'
}

{ #category : #accessing }
MooseLoadFamixSQLMenuCommand class >> help [

	^ 'Famix Metamodel for SQL'
]

{ #category : #accessing }
MooseLoadFamixSQLMenuCommand class >> label [

	^ 'Famix-SQL'
]

{ #category : #accessing }
MooseLoadFamixSQLMenuCommand class >> menuPriority [

	^super menuPriority + 1
]

{ #category : #accessing }
MooseLoadFamixSQLMenuCommand >> baselineName [

	^ 'FamixSQL'
]

{ #category : #accessing }
MooseLoadFamixSQLMenuCommand >> repositoryURL [

	^ 'github://moosetechnology/FamixSQL:' , self version , '/src'
]

{ #category : #accessing }
MooseLoadFamixSQLMenuCommand >> version [

	^ 'main'
]
