import React from 'react';

class Category extends React.Component {
  constructor(props) {
    super(props);
  };

  render() {
    return (
      <div>
        <label htmlFor='category'>Appointment Categories</label>
        <select name='category' onChange={this.props.selectCategory}>
          {this.props.categories.map(category =>
            <option key={category.id} value={category.id}>{category.name}</option>
          )}
        </select>

        <p>{this.props.selectedCategory}</p>
      </div>
    )
  }
}

export default Category;
