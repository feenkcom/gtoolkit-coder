Extension { #name : #RBCommentChange }

{ #category : #'*GToolkit-Coder' }
RBCommentChange >> gtChangesFor: aView [
	<gtView>
	^ aView explicit
		title: 'Diff';
		priority: 10;
		stencil: [ self gtDiff asElement ]
]

{ #category : #'*GToolkit-Coder' }
RBCommentChange >> gtDiff [
	| oldSource newSource |
	oldSource := (self changeClass ifNotNil: [ :cls | cls comment ])
		ifNil: [ '' ].
	newSource := comment.
	^ TextDiffBuilder
		from: oldSource
		to: newSource
		inClass: self changeClass
]
