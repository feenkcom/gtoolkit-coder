Extension { #name : #TBlDevScripterActionStep }

{ #category : #'*GToolkit-Coder-UI' }
TBlDevScripterActionStep >> filterStep [
	^ self
		addStep: (GtFilterStep new
				label: 'Filter';
				referenceSender;
				onParentStepTarget: self;
				onThisOrBreadthFirstChildOfKind: GtFilterItemsElement)
]
