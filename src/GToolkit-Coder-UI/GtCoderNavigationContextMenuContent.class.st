Class {
	#name : #GtCoderNavigationContextMenuContent,
	#superclass : #GtAbstractCoderContextMenuContent,
	#category : #'GToolkit-Coder-UI-Navigation'
}

{ #category : #accessing }
GtCoderNavigationContextMenuContent >> menuItemStencil [
	^ [ :e | 
	BrHorizontalPane new
		hMatchParent;
		vFitContent;
		alignCenter;
		aptitude: self selectionAptitude;
		padding: self itemPadding;
		when: BlClickEvent
			do: [ e value cull: self anchor.
				self anchor
					dispatchEvent: (BrContextMenuHideWish new
							anchor: self anchor;
							yourself) ];
		addChild: (self itemLabelFor: e key);
		yourself ]
]
