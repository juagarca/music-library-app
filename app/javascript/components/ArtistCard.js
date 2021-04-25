import React from "react"
import PropTypes from "prop-types"

class ArtistCard extends React.Component {
  render () {
    return (
      <React.Fragment>
        <div className="artist-card" style={{
            backgroundImage: `linear-gradient(to right, rgba(0,0,0,0.3), rgba(0,0,0,0.3)), url(${this.props.photoUrl})` 
        }}>
            {this.props.name}
        </div> 
      </React.Fragment>
    );
  }
}


ArtistCard.propTypes = {
  name: PropTypes.string,
  photoUrl: PropTypes.string
};

export default ArtistCard
