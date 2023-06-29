using AutoMapper;
using FirebaseAdmin.Auth;
using VolumeVaultInfra.Book.Hug.Models;
using VolumeVaultInfra.Book.Hug.Models.Base;

namespace VolumeVaultInfra.Book.Hug.Mapper.Profiles;

public class UserRecordUserInfoMapperProfile : Profile
{
    public UserRecordUserInfoMapperProfile()
    {
        CreateMap<UserRecord, UserInfo>();
    }
}