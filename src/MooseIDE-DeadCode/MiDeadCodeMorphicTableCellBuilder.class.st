"
This is a hack class, to add tool tips to rows in the list of heuristics
Only works for Morphic
"
Class {
	#name : 'MiDeadCodeMorphicTableCellBuilder',
	#superclass : 'SpMorphicTableCellBuilder',
	#category : 'MooseIDE-DeadCode',
	#package : 'MooseIDE-DeadCode'
}

{ #category : 'private' }
MiDeadCodeMorphicTableCellBuilder >> addCellMorph: morph column: aTableColumn [
	"this adds a tooltip to each cell in the table column"

	morph setBalloonText: self item description.

	^super addCellMorph: morph column: aTableColumn
]
