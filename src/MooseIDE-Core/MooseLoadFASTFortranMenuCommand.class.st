Class {
	#name : #MooseLoadFASTFortranMenuCommand,
	#superclass : #MooseAbstractLoadFASTMenuCommand,
	#category : #'MooseIDE-Core-MenuBar'
}

{ #category : #accessing }
MooseLoadFASTFortranMenuCommand class >> help [

	^ 'Famix representation of Fortran AST'
]

{ #category : #accessing }
MooseLoadFASTFortranMenuCommand class >> label [

	^ 'FAST Fortran'
]

{ #category : #'world menu' }
MooseLoadFASTFortranMenuCommand class >> menuCommandOn: aBuilder [

	<worldMenu>
	^ (self menuCommandOn: aBuilder forCommand: self)
		  withSeparatorAfter;
		  yourself
]

{ #category : #accessing }
MooseLoadFASTFortranMenuCommand class >> menuPriority [

	^ super menuPriority + 3
]

{ #category : #accessing }
MooseLoadFASTFortranMenuCommand >> baselineName [

	^ 'FASTFortran'
]

{ #category : #accessing }
MooseLoadFASTFortranMenuCommand >> repositoryURL [

	^ 'github://moosetechnology/FAST-Fortran' , '/src'
]

{ #category : #accessing }
MooseLoadFASTFortranMenuCommand >> version [

	^ 'v1'
]
