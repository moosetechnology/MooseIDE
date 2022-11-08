"
I am an abstract printer. Used to print objects in a stream.
"
Class {
	#name : #MiAbstractReportPrinter,
	#superclass : #Object,
	#instVars : [
		'micBuilder',
		'stream'
	],
	#category : #'MooseIDE-Export-Notebook'
}

{ #category : #printing }
MiAbstractReportPrinter >> initialize [

	super initialize.
	micBuilder := Microdown builder.
]

{ #category : #printing }
MiAbstractReportPrinter >> print: aCollection [

	self shouldBeImplemented
]

{ #category : #accessing }
MiAbstractReportPrinter >> stream [

	^ stream
]

{ #category : #accessing }
MiAbstractReportPrinter >> stream: anObject [

	stream := anObject.
	micBuilder setStream: stream
]
