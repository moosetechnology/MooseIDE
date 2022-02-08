Class {
	#name : #MiSourceTextIdentifierHighlight,
	#superclass : #MiSourceTextHighlight,
	#category : #'MooseIDE-Famix-SourceText'
}

{ #category : #formatting }
MiSourceTextIdentifierHighlight >> apply [
	self referenceText 
		addAttribute: TextEmphasis underlined from: self from to: self to ;
		addAttribute: TextEmphasis italic from: self from to: self to ;
		addAttribute: (TextDoIt new
			actOnClickBlock: [ self textBrowser selected: self highlightedEntity ])  from: self from to: self to ;
		addAttribute: TextColor black from: self from to: self to.

]

{ #category : #api }
MiSourceTextIdentifierHighlight >> setInterval: anInterval [
	"sets the interval to the 1st line containing the entity identifier"
	| myStart |
	myStart := self referenceText
		findString: self highlightedEntity name
		startingAt: anInterval first.
.
	self interval:
		(Interval
			from: myStart
			to: (myStart + self highlightedEntity name size - 1))

]
