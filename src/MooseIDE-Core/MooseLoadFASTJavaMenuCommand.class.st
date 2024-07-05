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

{ #category : #accessing }
MooseLoadFASTJavaMenuCommand class >> menuCommandOn: aBuilder [

	<worldMenu>
	^ (self menuCommandOn: aBuilder forCommand: self) yourself
]

{ #category : #accessing }
MooseLoadFASTJavaMenuCommand class >> menuPriority [

	^ super menuPriority + 1
]

{ #category : #accessing }
MooseLoadFASTJavaMenuCommand >> baselineName [

	^ 'FASTJava'
]

{ #category : #executing }
MooseLoadFASTJavaMenuCommand >> execute [
	"override to load a specific group of the baseline: #all"

	Metacello new
		baseline: self baselineName;
		repository: self repositoryURL;
		onConflictUseIncoming;
		load: #all
]

{ #category : #accessing }
MooseLoadFASTJavaMenuCommand >> repositoryURL [

	^ 'github://moosetechnology/FAST-JAVA:' , self version , '/src'
]

{ #category : #accessing }
MooseLoadFASTJavaMenuCommand >> version [

	^ 'v3'
]
