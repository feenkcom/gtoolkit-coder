Class {
	#name : #GtCoderNavigationContextMenuContent,
	#superclass : #BrSimpleList,
	#category : #'GToolkit-Coder-UI-Navigation'
}

{ #category : #accessing }
GtCoderNavigationContextMenuContent >> initialize [
	super initialize.
	self
		stencil: [ :e | 
			BlElement new
				viewModel: (BrInteractiveModel new
						withHover;
						yourself);
				aptitude: (BrStyleCommonAptitude new
						hovered: [ :aStyle | aStyle background: self theme item selectedColor ]);
				layout: BlLinearLayout horizontal;
				constraintsDo: [ :c | 
					c horizontal matchParent.
					c vertical fitContent ];
				padding: (BlInsets top: 2 bottom: 2);
				when: BlClickEvent
					do: [ e value cull: self anchor.
						self anchor
							dispatchEvent: (BrContextMenuHideWish new
									anchor: self anchor;
									yourself) ];
				addChild: (BrLabel new
						aptitude: BrGlamorousLabelAptitude;
						text: e key;
						yourself);
				yourself ];
		padding: (BlInsets
				top: 8
				right: 10
				bottom: 8
				left: 10);
		hFitContent;
		vFitContent
]
