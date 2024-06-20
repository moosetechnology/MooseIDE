Class {
	#name : #MooseLoadFamixFortranMenuCommand,
	#superclass : #MooseAbstractLoadModuleMenuCommand,
	#category : #'MooseIDE-Core-MenuBar'
}

{ #category : #accessing }
MooseLoadFamixFortranMenuCommand class >> help [

	^ 'Famix Metamodel for Fortran'
]

{ #category : #accessing }
MooseLoadFamixFortranMenuCommand class >> label [

	^ 'Famix-Fortran'
]

{ #category : #accessing }
MooseLoadFamixFortranMenuCommand class >> menuCommandOn: aBuilder [

	<worldMenu>
	^ self menuCommandOn: aBuilder forCommand: self
]

{ #category : #accessing }
MooseLoadFamixFortranMenuCommand class >> menuPriority [

	^ 21
]

{ #category : #accessing }
MooseLoadFamixFortranMenuCommand >> baselineName [

	^ 'FamixFortran'
]

{ #category : #accessing }
MooseLoadFamixFortranMenuCommand >> repositoryURL [

	^ 'github://moosetechnology/Famix-Fortran:' , self version , '/src'
]

{ #category : #accessing }
MooseLoadFamixFortranMenuCommand >> version [

	^ 'master'
]
