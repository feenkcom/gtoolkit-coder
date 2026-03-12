Extension { #name : #GtCoderRunTestAction }

{ #category : #'*GToolkit-Coder-UI' }
GtCoderRunTestAction >> buildElementIn: aCoderActionsElement [
	^BlElement	new
		viewModel: BrWidgetModel new;
		layout: BlLinearLayout horizontal;
		constraintsDo: [:c |
			c horizontal fitContent.  
			c vertical fitContent];
		addChild: (GtPharoMethodTestCaseStateElement new
			bindToCoderViewModel: aCoderActionsElement coderViewModel;
			constraintsDo: [:c |
				c linear vertical alignCenter ]);
		addChild: (aCoderActionsElement newButtonForAction: self)
]
