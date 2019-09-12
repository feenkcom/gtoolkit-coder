Class {
	#name : #GtCoderCommentStyler,
	#superclass : #GtCoderBodyStyler,
	#traits : 'TRBProgramNodeVisitor',
	#classTraits : 'TRBProgramNodeVisitor classTrait',
	#category : #'GToolkit-Coder-Styler/Highlighter'
}

{ #category : #visiting }
GtCoderCommentStyler >> visitNode: aNode [
	| comments |
	comments := aNode comments.
	comments notEmpty
		ifTrue: [ comments
				do: [ :each | 
					| comment document |
					"Hack to make sure we have the same indices for the part we are formatting"
					comment := ((String new: each start withAll: Character cr) , each contents) asRopedText.
					(text from: each start + 1 to: comment size)
						attributes: {(GtCompletionStrategyAttribute new strategy: GtDocumentCompletionStrategy new)}.
					document := GtDocument new.
					document editor useSyncStyler.
					document text: comment.
					comment := document text.
					each start + 1 to: comment size do: [ :i | (text from: i to: i) attributes: (comment attributesAt: i) ] ] ].
	^ super visitNode: aNode
]
