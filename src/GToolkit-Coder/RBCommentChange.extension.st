Extension { #name : #RBCommentChange }

{ #category : #'*GToolkit-Coder' }
RBCommentChange >> gtChangesFor: aView [
	<gtView>
	^ aView explicit
		title: 'Diff';
		priority: 10;
		stencil: [ self gtDiff asElement ]
]
