Extension { #name : #TBlDevScripterTarget }

{ #category : #'*GToolkit-Coder-UI' }
TBlDevScripterTarget >> onGtPharoSnippetPlayButton [
	self 
		id: #content;
		onChildOfClass: GtSourceCoderExpandedContentElement;
		id: #actions;
		onChildAt: 1; "BrToolbar"
		onChildAt: 1 "BrButton"
]
