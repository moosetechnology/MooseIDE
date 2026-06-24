"
A rewriter that adds a Java trace statement (`System.out.println(...`) after the first '{' of entities
"
Class {
	#name : 'MiBulkAddJavaTraceRewriter',
	#superclass : 'MiBulkAbstractRewriter',
	#instVars : [
		'searchStatmentBlock'
	],
	#category : 'MooseIDE-BulkEditor',
	#package : 'MooseIDE-BulkEditor'
}

{ #category : 'printing' }
MiBulkAddJavaTraceRewriter class >> commandLabel [

	^'Add trace instruction'
]

{ #category : 'actions' }
MiBulkAddJavaTraceRewriter >> beforeEol: c at: i [
	"Nothing to do before EOL
	Typically, only one of #beforeEol:at: , #afterEol:at: should be defined"

]

{ #category : 'actions' }
MiBulkAddJavaTraceRewriter >> beforeInterval: c [

	searchStatmentBlock := true.
	super beforeInterval: c 

]

{ #category : 'actions' }
MiBulkAddJavaTraceRewriter >> insideInterval: c [
	"if at start of method, insert trace"

	| tracer |

	super insideInterval: c.

	tracer := 'System.out.println(">>> {1}");' format: { interval data mooseName }.

	(searchStatmentBlock and: [ c = ${ ]) ifTrue: [
		searchStatmentBlock := false.
		stream
			<< Smalltalk os lineEnding ;
			<< tracer
	].

]
