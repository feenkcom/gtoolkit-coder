Extension { #name : #TBlDevScripterTarget }

{ #category : #'*GToolkit-Coder-UI' }
TBlDevScripterTarget >> onGtPharoSnippetDestinationButton [
	self 
		onChildNamed: #content;
		onChildOfClass: GtSourceCoderExpandedContentElement;
		onChildNamed: #switchButton
]

{ #category : #'*GToolkit-Coder-UI' }
TBlDevScripterTarget >> onGtPharoSnippetEditor [
	self 
		"onChildOfClass: GtExpandableCoderElement;"
		onChildNamed: #content;
		onChildOfClass: GtSourceCoderExpandedContentElement;
		onChildNamed: #editor
]

{ #category : #'*GToolkit-Coder-UI' }
TBlDevScripterTarget >> onGtPharoSnippetEvaluateButton [
	self 
		"onChildOfClass: GtExpandableCoderElement;"
		onChildNamed: #content;
		onChildOfClass: GtSourceCoderExpandedContentElement;
		onChildNamed: #actions;
		onChildAt: 1; "BrToolbar"
		"onChildOfClass: BrToolbar;"
		onChildAt: 1
]

{ #category : #'*GToolkit-Coder-UI' }
TBlDevScripterTarget >> onGtPharoSnippetInspectButton [
	self 
		"onChildOfClass: GtExpandableCoderElement;"
		onChildNamed: #content;
		onChildOfClass: GtSourceCoderExpandedContentElement;
		onChildNamed: #actions;
		onChildAt: 1; "BrToolbar"
		"onChildOfClass: BrToolbar;"
		onChildAt: 2
]

{ #category : #'*GToolkit-Coder-UI' }
TBlDevScripterTarget >> onGtPharoSnippetPlayButton [
	self 
		onChildNamed: #content;
		onChildOfClass: GtSourceCoderExpandedContentElement;
		onChildNamed: #actions;
		onChildAt: 1; "BrToolbar"
		onChildAt: 1 "BrButton"
]
