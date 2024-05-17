Class {
	#name : #MooseLoadFASTJavaMenuCommand,
	#superclass : #MooseAbstractLoadFASTMenuCommand,
	#category : #'MooseIDE-Core-MenuBar'
}

{ #category : #accessing }
MooseLoadFASTJavaMenuCommand class >> help [

	^ 'Famix representation of Java AST'
]

{ #category : #accessing }
MooseLoadFASTJavaMenuCommand class >> label [

	^ 'FAST Java'
]

{ #category : #'world menu' }
MooseLoadFASTJavaMenuCommand class >> menuCommandOn: aBuilder [

	<worldMenu>
	^ (self menuCommandOn: aBuilder forCommand: self) yourself
]

{ #category : #accessing }
MooseLoadFASTJavaMenuCommand class >> menuPriority [

	^ super menuPriority + 2
]

{ #category : #accessing }
MooseLoadFASTJavaMenuCommand >> baselineName [

	^ 'FASTJava'
]

{ #category : #accessing }
MooseLoadFASTJavaMenuCommand >> repositoryURL [

	^ 'github://moosetechnology/FAST-JAVA:' , self version , '/src'
]

{ #category : #accessing }
MooseLoadFASTJavaMenuCommand >> version [

	^ 'v3.x.x'
]
